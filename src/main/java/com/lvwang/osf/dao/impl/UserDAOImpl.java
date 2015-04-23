package com.lvwang.osf.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.lvwang.osf.dao.UserDAO;
import com.lvwang.osf.model.User;

@Repository("userDao")
public class UserDAOImpl implements UserDAO{

	private static final String TABLE = "osf_users"; 
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
		
	private User queryUser(String sql, Object[] args) {
		User user = jdbcTemplate.query(sql, args, new ResultSetExtractor<User>(){

			public User extractData(ResultSet rs) throws SQLException,
					DataAccessException {
				User user = null;
				if(rs.next()) {
					user = new User();
					user.setId(rs.getInt("id"));
					user.setUser_name(rs.getString("user_name"));
					user.setUser_email(rs.getString("user_email"));
					user.setUser_pwd(rs.getString("user_pwd"));
					user.setUser_registered_date(rs.getDate("user_registered_date"));
					user.setUser_status(rs.getInt("user_status"));	
					user.setUser_activationKey(rs.getString("user_activationKey"));
					user.setUser_avatar(rs.getString("user_avatar"));
				}
				return user;
			}

		});

		return user;
	}
	
	public User getUserByID(int id) {
		String sql = "select * from "+TABLE + " where id=?";
		return queryUser(sql, new Object[]{id});
	}

	public User getUserByEmail(String email) {
		String sql = "select * from " + TABLE + " where user_email=?";
		return queryUser(sql, new Object[]{email});
	}

	public User getUserByUsername(String username) {
		String sql = "select * from " + TABLE + " where user_name=?";
		return queryUser(sql, new Object[]{username});
	}

	public String getPwdByUsername(String username) {
		return null;
	}

	public User getUser(String condition, Object[] args){
		String sql = "select * from " + TABLE + " where "+condition+"=?";
		return queryUser(sql, args);
	}
	
	
	public List<User> getUsersByIDs(int[] ids) {
		StringBuffer sb = new StringBuffer();
		sb.append("select * from "+ TABLE+" where id in (");
		for(int i=0; i<ids.length; i++){
			if(i != 0)
				sb.append(",");
			sb.append(ids[i]);
		}
		sb.append(")");
		System.out.println(sb.toString());
		List<User> users = jdbcTemplate.query(sb.toString(), new RowMapper<User>(){

			public User mapRow(ResultSet rs, int rowNum) throws SQLException {
				User user = new User();
				user.setId(rs.getInt("id"));
				user.setUser_name(rs.getString("user_name"));
				user.setUser_email(rs.getString("user_email"));
				user.setUser_pwd(rs.getString("user_pwd"));
				user.setUser_registered_date(rs.getDate("user_registered_date"));
				user.setUser_status(rs.getInt("user_status"));	
				return user;
			}
		});
		return users;
		
	}
	
	//返回生成主键 user id
	public int save(final User user) {
		final String sql = "insert into " + TABLE + 
					 "(user_name, user_email, user_pwd, user_activationKey, user_status, user_avatar) "
					 + "values(?,?,?,?,?,?)";
		//jdbcTemplate.update(sql);
		
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(new PreparedStatementCreator() {
			
			public PreparedStatement createPreparedStatement(Connection con)
					throws SQLException {
				PreparedStatement ps = con.prepareStatement(sql, new String[]{"id"});
				ps.setString(1, user.getUser_name());
				ps.setString(2, user.getUser_email());
				ps.setString(3, user.getUser_pwd());
				ps.setString(4, user.getUser_activationKey());
				ps.setInt(5, user.getUser_status());
				ps.setString(6, user.getUser_avatar());
				return ps;
			}
		}, keyHolder );
		return keyHolder.getKey().intValue();
		
	}

	public int activateUser(final User user) {
		final String sql = "update " + TABLE + " set user_status=?, user_activationKey=?"+
					 " where id=?";
		return jdbcTemplate.update(new PreparedStatementCreator() {
			
			public PreparedStatement createPreparedStatement(Connection con)
					throws SQLException {
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setInt(1, user.getUser_status());
				ps.setString(2, user.getUser_activationKey());
				ps.setInt(3, user.getId());
				return ps;
			}
		});
		
	}
	

	
	
	//delete user by user id
	public boolean delete(int id) {
		// TODO Auto-generated method stub
		String sql = "delete from " + TABLE + " where id=";
		int effrows = jdbcTemplate.update(sql, id);
		return effrows==1?true:false;
		
	}
	
	
}
