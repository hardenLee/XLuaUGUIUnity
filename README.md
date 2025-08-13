通过xLua框架为Unity提供Lua编程能⼒，以实现Lua脚本对C#的调⽤；
通过Lua的表（table）来存储临时数据或函数内部的状态，定义了背包的数据结构；
通过xLua框架的LuaEnv类，实现⼀个Lua解析器管理器，⽤于调⽤Lua脚本中的函数和垃圾回收；
通过LuaEnv提供的AddLoader⽅法，实现Lua⽂件的加载重定向，满⾜我们需要加载其他路径下脚本的需求；
通过LuaEnv提供的Globals.Set⽅法，将C#类的实例注册到Lua的全局变量中，实现Lua脚本对C#类的实例的访问；
