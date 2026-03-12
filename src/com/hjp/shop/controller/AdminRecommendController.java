package com.hjp.shop.controller;

import com.hjp.shop.model.Product;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.util.List;

/**
 * 推荐商品管理控制器（仅管理员可访问）
 */
public class AdminRecommendController extends Controller {

	/**
	 * 推荐商品管理页面
	 */
	public void index() {
		// 获取当前推荐商品列表
		List<Product> recommendProducts = getRecommendProducts();
		setAttr("recommendProducts", recommendProducts);
		setAttr("recommendCount", recommendProducts.size());
		setAttr("pageTitle", "推荐商品管理 - 我的电商");
		render("/admin/recommend.html");
	}

	/**
	 * 获取可选商品列表（未在推荐表中的商品）
	 */
	public void availableProducts() {
		String sql = "SELECT * FROM tbl_product " +
				"WHERE id NOT IN (SELECT product_id FROM tbl_recommend_setting WHERE is_active = 1) " +
				"ORDER BY id DESC";
		List<Product> products = Product.dao.find(sql);
		renderJson(products);
	}

	/**
	 * 添加商品到推荐列表
	 */
	public void add() {
		Integer productId = getParaToInt("productId");
		if (productId == null) {
			renderJson(new Record().set("success", false).set("message", "商品ID不能为空"));
			return;
		}

		// 检查是否已存在
		Record existing = Db.findFirst("SELECT id FROM tbl_recommend_setting WHERE product_id = ?", productId);
		if (existing != null) {
			// 如果已存在但禁用，则重新启用
			Db.update("UPDATE tbl_recommend_setting SET is_active = 1 WHERE product_id = ?", productId);
		} else {
			// 获取最大排序值
			Integer maxOrder = Db.queryInt("SELECT MAX(sort_order) FROM tbl_recommend_setting");
			int newOrder = (maxOrder == null) ? 0 : maxOrder + 1;

			// 插入新记录
			Db.update("INSERT INTO tbl_recommend_setting (product_id, sort_order, is_active) VALUES (?, ?, 1)",
					productId, newOrder);
		}

		renderJson(new Record().set("success", true).set("message", "添加成功"));
	}

	/**
	 * 从推荐列表移除商品
	 */
	public void remove() {
		Integer productId = getParaToInt("productId");
		if (productId == null) {
			renderJson(new Record().set("success", false).set("message", "商品ID不能为空"));
			return;
		}

		Db.update("DELETE FROM tbl_recommend_setting WHERE product_id = ?", productId);

		// 重新整理排序
		reorderRecommendations();

		renderJson(new Record().set("success", true).set("message", "移除成功"));
	}

	/**
	 * 更新推荐商品排序
	 */
	public void updateSort() {
		String productIds = getPara("productIds");
		if (productIds == null || productIds.isEmpty()) {
			renderJson(new Record().set("success", false).set("message", "商品ID列表不能为空"));
			return;
		}

		String[] ids = productIds.split(",");
		for (int i = 0; i < ids.length; i++) {
			try {
				int productId = Integer.parseInt(ids[i].trim());
				Db.update("UPDATE tbl_recommend_setting SET sort_order = ? WHERE product_id = ?", i, productId);
			} catch (NumberFormatException e) {
				// 忽略无效ID
			}
		}

		renderJson(new Record().set("success", true).set("message", "排序更新成功"));
	}

	/**
	 * 调整推荐商品数量
	 * 如果目标数量大于当前，随机添加
	 * 如果目标数量小于当前，按排序移除多余的
	 */
	public void adjustCount() {
		Integer targetCount = getParaToInt("targetCount");
		if (targetCount == null || targetCount < 1 || targetCount > 50) {
			renderJson(new Record().set("success", false).set("message", "数量必须在1-50之间"));
			return;
		}

		int currentCount = Db.queryInt("SELECT COUNT(*) FROM tbl_recommend_setting WHERE is_active = 1");

		if (targetCount > currentCount) {
			// 需要添加商品
			int needAdd = targetCount - currentCount;
			String sql = "SELECT id FROM tbl_product " +
					"WHERE id NOT IN (SELECT product_id FROM tbl_recommend_setting WHERE is_active = 1) " +
					"ORDER BY RAND() LIMIT ?";
			List<Record> records = Db.find(sql, needAdd);

			int maxOrder = Db.queryInt("SELECT COALESCE(MAX(sort_order), -1) FROM tbl_recommend_setting") + 1;
			for (Record record : records) {
				Db.update("INSERT INTO tbl_recommend_setting (product_id, sort_order, is_active) VALUES (?, ?, 1)",
						record.getInt("id"), maxOrder++);
			}
		} else if (targetCount < currentCount) {
			// 需要移除商品，按排序移除排在后面的
			int needRemove = currentCount - targetCount;
			Db.update("DELETE FROM tbl_recommend_setting WHERE product_id IN (" +
					"SELECT product_id FROM (SELECT product_id FROM tbl_recommend_setting ORDER BY sort_order DESC LIMIT ?) AS tmp" +
					")", needRemove);
		}

		// 重新整理排序
		reorderRecommendations();

		renderJson(new Record().set("success", true).set("message", "数量调整成功"));
	}

	/**
	 * 获取当前推荐商品列表（内部方法）
	 */
	private List<Product> getRecommendProducts() {
		String sql = "SELECT p.* FROM tbl_product p " +
				"INNER JOIN tbl_recommend_setting r ON p.id = r.product_id " +
				"WHERE r.is_active = 1 " +
				"ORDER BY r.sort_order ASC, r.created_at DESC";
		return Product.dao.find(sql);
	}

	/**
	 * 重新整理排序（按当前顺序重新编号）
	 */
	private void reorderRecommendations() {
		List<Record> records = Db.find("SELECT product_id FROM tbl_recommend_setting WHERE is_active = 1 ORDER BY sort_order ASC");
		int order = 0;
		for (Record record : records) {
			Db.update("UPDATE tbl_recommend_setting SET sort_order = ? WHERE product_id = ?",
					order++, record.getInt("product_id"));
		}
	}
}
