
package config;

import java.io.InputStream;
import java.util.Properties;

import com.hjp.shop.Interceptor.LoginInterceptor;
import com.hjp.shop.controller.AdminController;
import com.hjp.shop.controller.AdminRecommendController;
import com.hjp.shop.controller.CartController;
import com.hjp.shop.controller.CategoryController;
import com.hjp.shop.controller.IndexController;
import com.hjp.shop.controller.OrderController;
import com.hjp.shop.controller.ProductController;
import com.hjp.shop.controller.ReportController;
import com.hjp.shop.controller.UserController;
import com.hjp.shop.model.Category;
import com.hjp.shop.model.Product;
import com.hjp.shop.model.Salesitem;
import com.hjp.shop.model.Salesorder;
import com.hjp.shop.model.User;
import com.jfinal.config.*;
import com.jfinal.core.JFinal;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.c3p0.C3p0Plugin;

public class ShopConfig extends JFinalConfig {

	private static String jdbcUrl;
	private static String jdbcUser;
	private static String jdbcPassword;
	private static String jdbcDriver;
	private static int serverPort;

	static {
		Properties p = new Properties();
		try (InputStream in = ShopConfig.class.getClassLoader().getResourceAsStream("config.properties")) {
			if (in != null) {
				p.load(in);
				jdbcUrl = p.getProperty("jdbc.url", "jdbc:mysql://127.0.0.1:3306/shopping?serverTimezone=Asia/Shanghai&useSSL=false");
				jdbcUser = p.getProperty("jdbc.username", "root");
				jdbcPassword = p.getProperty("jdbc.password", "root");
				jdbcDriver = p.getProperty("jdbc.driver", "com.mysql.cj.jdbc.Driver");
				serverPort = Integer.parseInt(p.getProperty("server.port", "8090"));
			} else {
				jdbcUrl = "jdbc:mysql://127.0.0.1:3306/shopping?serverTimezone=Asia/Shanghai&useSSL=false";
				jdbcUser = "root";
				jdbcPassword = "root";
				jdbcDriver = "com.mysql.cj.jdbc.Driver";
				serverPort = 8090;
			}
		} catch (Exception e) {
			jdbcUrl = "jdbc:mysql://127.0.0.1:3306/shopping?serverTimezone=Asia/Shanghai&useSSL=false";
			jdbcUser = "root";
			jdbcPassword = "root";
			jdbcDriver = "com.mysql.cj.jdbc.Driver";
			serverPort = 8090;
		}
	}

	@Override
	public void configConstant(Constants me) {
		me.setDevMode(true);
	}

	@Override
	public void configRoute(Routes me) {
		me.add("/user", UserController.class);
		me.add("/admin", AdminController.class);
		me.add("/admin/recommend", AdminRecommendController.class);
		me.add("/recommend", com.hjp.shop.controller.RecommendController.class);
		me.add("/", IndexController.class);
		me.add("/category", CategoryController.class);
		me.add("/product", ProductController.class);
		me.add("/cart", CartController.class);
		me.add("/order", OrderController.class);
		me.add("/report", ReportController.class);
	}

	@Override
	public void configPlugin(Plugins me) {
		C3p0Plugin cp = new C3p0Plugin(jdbcUrl, jdbcUser, jdbcPassword, jdbcDriver);
		me.add(cp);
		ActiveRecordPlugin arp = new ActiveRecordPlugin(cp);
		me.add(arp);
		arp.addMapping("tbl_user", User.class);
		arp.addMapping("tbl_category", Category.class);
		arp.addMapping("tbl_product", Product.class);
		arp.addMapping("tbl_recommend_setting", com.hjp.shop.model.RecommendSetting.class);
		arp.addMapping("tbl_salesitem", Salesitem.class);
		arp.addMapping("tbl_salesorder", Salesorder.class);
	}

	@Override
	public void configInterceptor(Interceptors me) {
		me.add(new LoginInterceptor());
	}

	@Override
	public void configHandler(Handlers me) {
	}

	public static void main(String[] args) {
		JFinal.start("WebRoot", serverPort, "/", 5);
	}
}
