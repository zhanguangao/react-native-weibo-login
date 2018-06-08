/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Image,
} from 'react-native';
import * as WeiBo from 'react-native-weibo-login';

type Props = {};
export default class App extends Component<Props> {

  constructor(props){
    super(props);
    this.state={
      data:''
    }
  }

  wbLogin=()=>{
    // 设置登录参数 
    let config = {
        appKey:"2317411734",
        scope: 'all',       
        redirectURI: 'https://api.weibo.com/oauth2/default.html',
    }
    WeiBo.login(config)
      .then(res=>{  
         console.log('login success:',res)
         this.setState({data:res})
      }).catch(err=>{ 
        console.log('login fail:',err)
        this.setState({data:err.errMsg})
      })
}

renderWeiboLogin(){
    return(
        <View style={{marginTop:100}}>
          <View style={{flexDirection:'row',alignItems:'center'}}>
              <View style={styles.loginLine}></View>
              <Text style={{fontSize:13,color:"#A0A0A0"}}>  第三方登录  </Text>
              <View style={styles.loginLine}></View>
          </View>
          <View style={styles.loginContainer}>
              <TouchableOpacity 
                  activeOpacity={0.8}
                  onPress={this.wbLogin}
                  style={styles.loginItem}>
                  <Image
                      style={styles.loginIcon}
                      source={require('./src/login_weibo.png')}
                  />
                  <Text style={styles.loginText}>微博</Text>
              </TouchableOpacity>           
          </View>
        </View>
    )
}

render() {
  return (
    <View style={styles.container}>

      <View style={{marginTop:100}}>
        <Text style={styles.text}>微博登录回调信息:</Text>
        <Text style={styles.text}>
          {this.state.data?JSON.stringify(this.state.data):'未授权'}
        </Text>    
      </View>     

      {this.renderWeiboLogin()}  
    </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1, 
    marginHorizontal:20
  },
  text:{
    fontSize:15,
    lineHeight:25,
  },

  loginContainer:{
    marginTop:25,
    flexDirection:'row',
    justifyContent:'space-around'
  },
  loginItem:{
    alignItems:'center',
  },
  loginLine:{
    flex:1,
    backgroundColor:"#ECECEC",
    height:1
  },
  loginIcon:{
      width:50,
      height:50
  },
  loginText:{
      fontSize:13,
      color:'#444444',
      marginTop:10
  },
 
});
