package com.hjp.shop.controller;

import com.hjp.shop.model.Product;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.util.ArrayList;
import java.util.List;

/**
 * 推荐商品页：从推荐商品表读取，无分页，轮盘循环展示
 */
public class RecommendController extends Controller {

	/**
	 * 推荐商品首页 - 从推荐表读取商品，固定数量轮盘展示
	 */
	public void index() {
		// 查询已配置的推荐商品
		List<Product> recommendProducts = getRecommendProducts();

		// 如果推荐表为空，随机初始化10个商品
		if (recommendProducts.isEmpty()) {
			initRecommendProducts(10);
			recommendProducts = getRecommendProducts();
		}

		setAttr("products", recommendProducts);
		setAttr("productCount", recommendProducts.size());
		setAttr("pageTitle", "推荐商品 - 我的电商");
		setAttr("isRecommendPage", true);
		render("/recommend.html");
	}

	/**
	 * 获取推荐商品列表（按排序顺序）
	 */
	private List<Product> getRecommendProducts() {
		String sql = "SELECT p.* FROM tbl_product p " +
				"INNER JOIN tbl_recommend_setting r ON p.id = r.product_id " +
				"WHERE r.is_active = 1 " +
				"ORDER BY r.sort_order ASC, r.created_at DESC";
		return Product.dao.find(sql);
	}

	/**
	 * 随机初始化推荐商品
	 * @param count 初始化数量
	 */
	private void initRecommendProducts(int count) {
		// 随机选择商品ID
		String selectSql = "SELECT id FROM tbl_product ORDER BY RAND() LIMIT ?";
		List<Record> records = Db.find(selectSql, count);

		// 插入推荐表
		int sortOrder = 0;
		for (Record record : records) {
			Integer productId = record.getInt("id");
			Db.update("INSERT INTO tbl_recommend_setting (product_id, sort_order, is_active) VALUES (?, ?, 1)",
					productId, sortOrder++);
		}
	}
}
