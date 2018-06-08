
import { NativeModules, NativeEventEmitter } from 'react-native';

const { WeiBo } = NativeModules
//创建原生监听器
const WeiBoNativeEventEmitter = new NativeEventEmitter(WeiBo)
/*
* Scope 是 OAuth2.0 授权机制中 authorize 接口的一个参数。通过 Scope，平台将开放更多的微博
* 核心功能给开发者，同时也加强用户隐私保护，提升了用户体验，用户在新 OAuth2.0 授权页中有权利
* 选择赋予应用的功能。
* 目前 Scope 支持传入多个 Scope 权限，用逗号分隔。
* 
* 有关哪些 OpenAPI 需要权限申请，请查看：http://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9AAPI
* 关于 Scope 概念及注意事项，请查看：http://open.weibo.com/wiki/Scope
* */

const defaultScope = "all"
// 默认 'https://api.weibo.com/oauth2/default.html'
// 必须和sina微博开放平台中应用高级设置中的redirectURI设置的一致，不然会登录失败
const defaultRedirectURI = "https://api.weibo.com/oauth2/default.html"

function checkConfig(config) {
    if(!config.redirectURI) {
        config.redirectURI = defaultRedirectURI
    }
    if(!config.scope) {
        config.scope = defaultScope
    }
}

let weiBoAuthListener
const WeiBoLoginEventName = 'weibo_login'

export function login(config={}) {
    return new Promise((resolve,reject)=>{
        checkConfig(config)
        //此回调只会返回SDK是否调用成功，授权登录是否成功通过监听返回
        WeiBo.login(config,(status)=>{
            console.log(status)
        });
        weiBoAuthListener = WeiBoNativeEventEmitter.addListener(WeiBoLoginEventName,(data)=>{
            weiBoAuthListener.remove()
            if(data.errCode == 0){   //login success
                resolve(data)
            }else{   //login fail
                reject(data)              
            }                
        })
    })
   
}