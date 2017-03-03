###
 从SQL建表语句创建java对象

CREATE TABLE `wrd_word_info` (
`word_id` int(11) NOT NULL COMMENT '单词id',
`wb_no` smallint(6) NOT NULL COMMENT '批次号',
`word` varchar(100) NOT NULL COMMENT '英文单词',
`paraphrase` varchar(500) DEFAULT '' COMMENT '中文释义',
`phonetic` varchar(100) DEFAULT NULL COMMENT '音标',
`example` text COMMENT '例句',
`net_file` varchar(255) DEFAULT NULL COMMENT '发音文件',
`word_desc` varchar(255) DEFAULT '' COMMENT '备注',
`source` varchar(100) DEFAULT '' COMMENT '来源',
PRIMARY KEY (`word_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='词汇基本信息表';

###
class SQLJavaDbOrmlite extends FiledsJavaDbOrmlite
  constructor: () ->

  toJava: (sqlStr, opts) ->
    filedStr = @parseSql2FiledsStr sqlStr, opts
    super filedStr, opts

  parseSql2FiledsStr: (sqlStr, opts) ->
    # TODO: 解析表名、类名
    reg = /CREATE +TABLE +([`|\S]+) +\(/i
    className = sqlStr.match(reg)?[1]
    reg = /`(\S+)`/
    if(reg.test(className))
      opts.className = className.match(reg)[1]
    else
      opts.className = className if className?
    sqlStr.split(',').join('\n')

    # TODO: 在这里解析sql成fileds字符串
    sqlS=sqlStr.split('\n')
    reg = /([`|\S]+) +(COMMENT +'(.*?)' ?,)/i
    regName = /`\S+`/i
    regType =  /\S+\(/i
    regNote =  /'\S+'/i
    regKey =  /PRIMARY KEY/i
    regBrackets = /\(/i
    strFiles = {}
    strKeyName=''
    for value,key in sqlS
      if(value.match(reg))
        strName = value.match(regName)
        strName = strName[0].substring(1,strName[0].length-1)
        value = value.replace /^\s+/g, ""
        strTypeValue = value.split(' ');
        strType = strTypeValue[1]
        if(strType.match(regBrackets))
          strType = strType.match(regType)
          strType = strType[0].substring(0,strType[0].length-1)
        strNote = value.match(regNote)
        strNote = strNote[0].substring(1,strNote[0].length-1)
        switch strType
          when "varchar","char","nchar","nvarchar","longtext","text","ntext","sql_variant","uniqueidentifier" then strType = "String"
          when "smallint","int","tinyint" then strType = "int"
          when 'bit' then strType = "boolean"
          when 'bigint',"datetime" then strType = "long"
          when 'float',"real" then strType = "float"
          when 'double' then strType = "double"
        strFile = "private " +strType+" "+strName+";//"+strNote+"\n"
        strFiles[strName] = strFile
      else if(value.match(regKey))
        strKeyName = value.match(regName)
        strKeyName = strKeyName[0].substring(1,strKeyName[0].length-1)
      console.log strFiles
    keyStr = strFiles[strKeyName]
    delete strFiles[strKeyName]
    resultArr = []
    resultArr.push keyStr
    for key, value of strFiles
      resultArr.push value
    console.log resultArr.join '\n'
    resultArr.join('\n')
    #private String word_desc;//发音文件\nprivate String word_desc;//发音文件"
# sql="""CREATE TABLE `wrd_word_info` (
# `word_id` int(11) NOT NULL COMMENT '单词id',
# `wb_no` smallint(6) NOT NULL COMMENT '批次号',
# `word` varchar(100) NOT NULL COMMENT '英文单词',
# `paraphrase` varchar(500) DEFAULT '' COMMENT '中文释义',
# `phonetic` varchar(100) DEFAULT NULL COMMENT '音标',
# `example` text COMMENT '例句',
# `net_file` varchar(255) DEFAULT NULL COMMENT '发音文件',
# `word_desc` varchar(255) DEFAULT '' COMMENT '备注',
# `source` varchar(100) DEFAULT '' COMMENT '来源',
# PRIMARY KEY (`word_id`)
# ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='词汇基本信息表';"""
# private String word_desc;//发音文件
