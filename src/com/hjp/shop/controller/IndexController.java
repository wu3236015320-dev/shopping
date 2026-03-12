package com.hjp.shop.controller;

import java.util.List;

import com.hjp.shop.model.Product;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.aop.ClearLayer;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

public class IndexController extends Controller {

	/** 首页每页显示商品数（70 个商品共 6 页：70÷12≈6） */
	private static final int INDEX_PAGE_SIZE = 12;

	/** 显式绑定根路径，确保访问 / 一定走分页逻辑，避免被 welcome-file 或静态资源覆盖 */
	@ActionKey("/")
	public void index() {
		String uri = getRequest().getRequestURI();
		boolean isRecommendPage = uri != null && uri.contains("/recommend");

		int pageNo = 1;
		String pageParam = getPara("page");
		if (pageParam == null || pageParam.isEmpty()) {
			pageParam = getPara(0);
		}
		if (pageParam != null && !pageParam.isEmpty()) {
			try {
				pageNo = Integer.parseInt(pageParam.trim());
				if (pageNo < 1) pageNo = 1;
			} catch (NumberFormatException e) {
				pageNo = 1;
			}
		}
		// 与 product/list 同一张表：总数 70 时首页 6 页，每页 12 条
		long totalRow = Db.queryLong("select count(*) from tbl_product");
		int totalPage = (totalRow <= 0) ? 1 : (int) ((totalRow + INDEX_PAGE_SIZE - 1) / INDEX_PAGE_SIZE);
		if (pageNo > totalPage) pageNo = totalPage;
		if (pageNo < 1) pageNo = 1;

		Page<Product> page = Product.dao.getLatestProductPage(pageNo, INDEX_PAGE_SIZE);
		setAttr("products", page.getList());
		setAttr("pageNo", Integer.valueOf(pageNo));
		setAttr("pageCount", Integer.valueOf(totalPage));
		setAttr("pageSize", Integer.valueOf(INDEX_PAGE_SIZE));
		setAttr("isRecommendPage", isRecommendPage);
		setAttr("info", isRecommendPage ? "推荐商品" : "首页");
		if (isRecommendPage) {
			setAttr("pageTitle", "推荐商品 - 我的电商");
		}
		render("/index.html");
	}

	/** 兼容 welcome-file：/index.html 与 / 使用同一套分页，可翻页查看全部商品 */
	@ActionKey("/index.html")
	public void indexHtml() {
		index();
	}

	/** 调试：浏览器访问 http://127.0.0.1:8090/checkProductCount 可查看数据库商品条数 */
	@ClearInterceptor(ClearLayer.ALL)
	@ActionKey("/checkProductCount")
	public void checkProductCount() {
		int count = 0;
		try {
			count = Product.dao.find("select id from tbl_product").size();
		} catch (Exception e) {
			renderText("error: " + e.getMessage());
			return;
		}
		renderText("productCount=" + count + " （若为 0 请执行 更新数据库-完整重置.bat）");
	}
	
	@ClearInterceptor(ClearLayer.ALL)
	@ActionKey("/log")
	public void log(){
		long pageSize = 10;
		long pageNo = 1;
		if( getPara()!=null){
			pageNo = getParaToLong();
		}
		long count  = Db.findFirst("select count(*) count from tbl_log").getLong("count");
		long pageCount = (count + pageSize -1) /pageSize;
		
		if(pageNo > pageCount){
			pageNo = pageCount;
		}
		List<Record> logPage = Db.paginate((int)pageNo, (int)pageSize, "select *", "from tbl_log order by id desc").getList(); 
		setAttr("pageNo", pageNo);
		setAttr("pageCount", pageCount);
		setAttr("logList", logPage);
		render("/log/list.html");
	}
}
