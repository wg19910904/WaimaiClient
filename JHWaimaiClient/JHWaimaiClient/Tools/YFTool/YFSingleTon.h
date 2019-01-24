
//.h文件
#define YFSingleTonH(ClassName)  +(instancetype)share##ClassName;

//.m文件
#define YFSingleTonM(ClassName) \
static id _instance=nil;\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(instancetype)share##ClassName{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance=[[self alloc] init];\
    });\
    return _instance;\
}\
-(instancetype)copyWithZone:(NSZone *)zone{\
    return _instance;\
}

