package com.hjp.shop.controller;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;

import com.hjp.shop.Interceptor.AdminInterceptor;
import com.hjp.shop.model.Category;
import com.hjp.shop.model.Product;
import com.hjp.shop.model.User;
import com.hjp.shop.model.Salesorder;
import com.hjp.shop.model.Salesitem;
import com.jfinal.aop.Before;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;

@Before(AdminInterceptor.class)
public class AdminController extends Controller {

	public void index() {
		setAttr("pageTitle", "管理后台 - 我的电商");
		render("index.html");
	}

	/**
	 * 商品管理页面
	 */
	public void product() {
		int pageNo = 1;
		if (getPara() != null) {
			try {
				pageNo = getParaToInt();
				if (pageNo < 1) pageNo = 1;
			} catch (Exception e) {
				pageNo = 1;
			}
		}
		int pageSize = 12;
		Page<Product> productPage = Product.dao.getLatestProductPage(pageNo, pageSize);
		List<Category> categories = Category.dao.getCategories();
		setAttr("products", productPage.getList());
		setAttr("categories", categories);
		setAttr("pageNo", pageNo);
		setAttr("pageCount", productPage.getTotalPage());
		setAttr("pageTitle", "商品管理 - 我的电商");
		render("product.html");
	}

	/**
	 * 订单管理页面
	 */
	public void order() {
		try {
			int pageNo = 1;
			if (getPara() != null) {
				try {
					pageNo = getParaToInt();
					if (pageNo < 1) pageNo = 1;
				} catch (Exception e) {
					pageNo = 1;
				}
			}
			long pageCount = Salesorder.dao.getCountPage();
			if (pageCount < 1) pageCount = 1;
			if (pageNo > pageCount) {
				pageNo = (int) pageCount;
			}
			List<Salesorder> oLists = Salesorder.dao.getAllOrder(pageNo);
			setAttr("pageNo", pageNo);
			setAttr("oLists", oLists);
			setAttr("pageCount", pageCount);
		} catch (Exception e) {
			setAttr("pageNo", 1);
			setAttr("oLists", new ArrayList<Salesorder>());
			setAttr("pageCount", 1);
		}
		setAttr("pageTitle", "订单管理 - 我的电商");
		render("order.html");
	}

	/**
	 * 用户管理页面
	 */
	public void user() {
		int pageNo = 1;
		if (getPara() != null) {
			try {
				pageNo = getParaToInt();
				if (pageNo < 1) pageNo = 1;
			} catch (Exception e) {
				pageNo = 1;
			}
		}
		Page<User> userPage = User.dao.getAllDate(pageNo);
		setAttr("pageNo", pageNo);
		setAttr("userPage", userPage.getList());
		setAttr("pageCount", userPage.getTotalPage());
		setAttr("pageTitle", "用户管理 - 我的电商");
		render("user.html");
	}

	/**
	 * 销售报表页面
	 */
	public void report() {
		try {
			List<Salesitem> salesItems = Salesitem.dao.find("SELECT productid, SUM(pcount) as total_count FROM tbl_salesitem GROUP BY productid ORDER BY total_count DESC LIMIT 10");
			List<String> productNames = new ArrayList<>();
			List<Integer> salesData = new ArrayList<>();
			for (Salesitem item : salesItems) {
				Integer productId = item.getInt("productid");
				Product product = Product.dao.findById(productId);
				if (product != null) {
					productNames.add("'" + product.getStr("name") + "'");
				} else {
					productNames.add("'商品" + productId + "'");
				}
				salesData.add(item.getInt("total_count"));
			}
			setAttr("productNames", "[" + String.join(",", productNames) + "]");
			setAttr("salesData", salesData);
		} catch (Exception e) {
			// 如果查询失败，使用空数据
			setAttr("productNames", "['暂无数据']");
			setAttr("salesData", new ArrayList<Integer>());
		}
		
		try {
			Long totalOrders = Db.queryLong("SELECT COUNT(*) FROM tbl_salesorder");
			Double totalSales = Db.queryDouble("SELECT COALESCE(SUM(amount), 0) FROM tbl_salesorder WHERE status = 1");
			if (totalSales == null) totalSales = 0.0;
			Double avgOrderAmount = (totalOrders > 0 && totalSales > 0) ? (totalSales / totalOrders) : 0.0;
			setAttr("totalOrders", totalOrders != null ? totalOrders : 0);
			setAttr("totalSales", String.format("%.2f", totalSales));
			setAttr("avgOrderAmount", String.format("%.2f", avgOrderAmount));
		} catch (Exception e) {
			setAttr("totalOrders", 0);
			setAttr("totalSales", "0.00");
			setAttr("avgOrderAmount", "0.00");
		}
		
		setAttr("pageTitle", "销售报表 - 我的电商");
		render("report.html");
	}

	public void searchUser() {
		String username = getPara("username");
		setAttr("user", User.dao.getUserByName(username));
	}

	public void listUser() {
		int pageNo;
		if (getPara()!=null) {
			try {
				pageNo = getParaToInt();
				if (pageNo <1 ) {
					pageNo = 1;
				}
			} catch (Exception e) {
				pageNo = 1;
				org.apache.log4j.Logger.getLogger(AdminController.class).warn("listUser pageNo parse error", e);
			}
		}else {
			pageNo = 1;
		}
		long pageCount = User.dao.getPageCount();
		if(pageNo > pageCount){
			pageNo =(int)pageCount;
		}
		this.setAttr("userPage", User.dao.getAllDate(pageNo));
		setAttr("pageNo",pageNo);
		setAttr("pageCount",pageCount);
		render("listUser.html");
	}

	public void addUser() {
		String username = getPara("username");
		if (username != null) {
			String password = User.EncoderByMd5(username + new Date()).substring(0,6);
			User user = new User().set("username", username).set("password", User.EncoderByMd5(password)).set("rdate",new Date()).set("phone", "10086").set("addr", "???????");
			if(user.save()){
				user.set("password", password);
				setAttr("newuser",user);
			}
		}
		render("addUser.html");
	}

	@ClearInterceptor
	public void login() {
		if (getPara("login") == null || !getPara("login").equals("ok")) {
			render("login.html");
			return;
		}
		String userName = getPara("username");
		String password = getPara("password");
		if (userName == null || userName.isEmpty() || password == null || password.isEmpty()) {
			setAttr("error", "请输入用户名和密码");
			render("login.html");
			return;
		}
		String passwordMd5 = User.EncoderByMd5(password);
		String dbPassword = User.dao.getPasswordByusername(userName);
		if (dbPassword != null && passwordMd5.equalsIgnoreCase(dbPassword)) {
			setSessionAttr("user", User.dao.getUserByName(userName));
			redirect("/admin");
			return;
		}
		setAttr("error", "用户名或密码错误");
		render("login.html");
	}

}
