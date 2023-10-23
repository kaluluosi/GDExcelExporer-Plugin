# warnings-disable
extends RefCounted

var True = true
var False = false
var None = null


var data = \
{
1:{ "id":1,  "int":1,  "float ":1.0,  "string":'恭喜你！成功配置好了Godot导表项目。',  "bool":True,  "array":[1, 2, 3, 4, 5],  "array_str":['a', 'b', 'c'],  "array_bool":[True, False],  "dict":{'name': 'Tom', 'age': 10},  "function":Callable(self,'function_1'),  "function_params":Callable(self,'function_params_1'),  "tr_string":'这段话需要翻译',  "tr_array_str":['a', 'b', 'c'],  "tr_dict":{'name': 'Tom', 'age': 10}, },
2:{ "id":2,  "int":0,  "float ":0.0,  "string":'aa',  "bool":True,  "array":[],  "array_str":[],  "array_bool":[],  "dict":{},  "function":Callable(self,'function_2'),  "function_params":Callable(self,'function_params_2'),  "tr_string":'',  "tr_array_str":[],  "tr_dict":{}, },
3:{ "id":3,  "int":2,  "float ":2.0,  "string":'',  "bool":False,  "array":[1, 2, 3],  "array_str":['b', 'c'],  "array_bool":[True],  "dict":{'name': 'Tom', 'age': 10},  "function":Callable(self,'function_3'),  "function_params":Callable(self,'function_params_3'),  "tr_string":'',  "tr_array_str":['b', 'c'],  "tr_dict":{'name': 'Tom', 'age': 10}, },
4:{ "id":4,  "int":3,  "float ":3.01,  "string":'',  "bool":True,  "array":[],  "array_str":[],  "array_bool":[],  "dict":{},  "function":Callable(self,'function_4'),  "function_params":Callable(self,'function_params_4'),  "tr_string":'',  "tr_array_str":[],  "tr_dict":{}, },
5:{ "id":5,  "int":4,  "float ":0.0,  "string":'你真可悲，你什么都不是，你毫无作为，你无足轻重，你一无是处。\n我，整个城市都是我的。\n等警察抓住你们的时候......你会死的毫无意义。这里是我的地盘。\n你...你....你就是人们要躲避的东西。',  "bool":True,  "array":[],  "array_str":[],  "array_bool":[],  "dict":{},  "function":Callable(self,'function_5'),  "function_params":Callable(self,'function_params_5'),  "tr_string":'',  "tr_array_str":[],  "tr_dict":{}, },
6:{ "id":6,  "int":0,  "float ":0.0,  "string":'',  "bool":True,  "array":[],  "array_str":[],  "array_bool":[],  "dict":{},  "function":Callable(self,'function_6'),  "function_params":Callable(self,'function_params_6'),  "tr_string":'',  "tr_array_str":[],  "tr_dict":{}, },

}


func function_1(args=[]):
    print(args)

func function_params_1(a,b=null,c=null):
    print(a)

func function_2(args=[]):
    pass

func function_params_2(a,b=null,c=null):
    pass

func function_3(args=[]):
    pass

func function_params_3(a,b=null,c=null):
    pass

func function_4(args=[]):
    pass

func function_params_4(a,b=null,c=null):
    pass

func function_5(args=[]):
    pass

func function_params_5(a,b=null,c=null):
    pass

func function_6(args=[]):
    pass

func function_params_6(a,b=null,c=null):
    pass
