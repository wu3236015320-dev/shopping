package com.hjp.shop.model;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;

public class Product extends Model<Product> {

	private static final long serialVersionUID = 1L;
	private static final int pageSize = 5;
	/** 前台首页、分类列表每页条数 */
	public static final int FRONT_PAGE_SIZE = 12;

	public static Product dao = new Product();
	
	public  Page<Product> getAllProduct(int pageNo){
		return this.paginate(pageNo,Product.pageSize, "select * ", " from tbl_product order by id asc");
	}
   /**
    * 取得条件符合的产品列表（参数化查询，防 SQL 注入）
    * @param categoryid  类别号
    * @param keyword  关键词
    * @param minNormalprice  最小正常价格
    * @param maxNormalprice 最大正常价格
    * @param minMemberprice 最小会员价格
    * @param maxMemberprice 最大会员价格
    * @param minpdate  最早上架时间
    * @param maxpdate 最晚上架时间
    * @return 产品列表
    */
	public List<Product> search(int categoryid,
												String keyword,
												int minNormalprice,
												int maxNormalprice,
												int minMemberprice,
												int maxMemberprice,
												Date minpdate,
												Date maxpdate) {
		StringBuilder sql = new StringBuilder("select * from tbl_product where 1=1 ");
		List<Object> paras = new java.util.ArrayList<>();
		if (categoryid > 0) {
			sql.append(" and categoryid = ? ");
			paras.add(categoryid);
		}
		if (keyword != null && !keyword.isEmpty()) {
			String likeArg = "%" + keyword + "%";
			sql.append(" and (name like ? or descr like ?) ");
			paras.add(likeArg);
			paras.add(likeArg);
		}
		if (minNormalprice > 0) {
			sql.append(" and normalprice > ? ");
			paras.add(minNormalprice);
		}
		if (maxNormalprice > 0) {
			sql.append(" and normalprice < ? ");
			paras.add(maxNormalprice);
		}
		if (minMemberprice > 0) {
			sql.append(" and memberprice > ? ");
			paras.add(minMemberprice);
		}
		if (maxMemberprice > 0) {
			sql.append(" and memberprice < ? ");
			paras.add(maxMemberprice);
		}
		if (minpdate != null) {
			sql.append(" and pdate > ? ");
			paras.add(new SimpleDateFormat("yyyy-MM-dd").format(minpdate));
		}
		if (maxpdate != null) {
			sql.append(" and pdate < ? ");
			paras.add(new SimpleDateFormat("yyyy-MM-dd").format(maxpdate));
		}
		return find(sql.toString(), paras.toArray());
	}
	
	public List<Product> getLatestProduct(int count) {
		return find("select * from tbl_product order by pdate desc limit ?", count);
	}

	/** 首页按上架时间分页，每页固定 FRONT_PAGE_SIZE 条 */
	public Page<Product> getLatestProductPage(int pageNo) {
		return getLatestProductPage(pageNo, FRONT_PAGE_SIZE);
	}

	/** 首页分页，可指定每页条数（用于保证首页固定 12 条） */
	public Page<Product> getLatestProductPage(int pageNo, int pageSize) {
		return paginate(pageNo, pageSize, "select *", "from tbl_product order by pdate desc");
	}

	/** 按分类分页查询 */
	public Page<Product> getProductByCidPage(int cid, int pageNo) {
		return paginate(pageNo, FRONT_PAGE_SIZE, "select *", "from tbl_product where categoryid = ? order by id asc", cid);
	}

	public List<Product> getProductByCid(int cid) {
		return find("select * from tbl_product where categoryid = ?", cid);
	}

}
