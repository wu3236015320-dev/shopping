package com.hjp.shop.model;

import java.util.List;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Model;

public class Salesitem extends Model<Salesitem> {

		private static final long serialVersionUID = 1L;
		public static Salesitem dao = new Salesitem();

		private static final Logger log = Logger.getLogger(Salesitem.class);
		
		public List<Salesitem> getAllItem(){
			return find("select productid,count(pcount) count from tbl_salesitem group by productid");
		}

		public List<Salesitem> getItemByOid(int oid) {
			if (log.isDebugEnabled()) {
				log.debug("getItemByOid oid=" + oid);
			}
			return find("select * from tbl_salesitem where orderid = ?", oid);
		}
		
		public Product getProduct(int pid){
			return Product.dao.findById(pid);
		}
}
