( function _EncodersExtended_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../files/l1/EncodersExtended.s' );

  _.include( 'wTesting' );

}

//

var _ = _global_.wTools;
var Parent = wTester;

//

function onSuiteBegin()
{
  let context = this;
  context.provider = _.FileProvider.HardDrive();
  let path = context.provider.path;
  context.testSuitePath = path.dirTempOpen( 'EncodersExtended' );
}

//

function onSuiteEnd()
{
  let path = this.provider.path;
  _.assert( _.strHas( this.testSuitePath, 'tmp.tmp' ) );
  path.dirTempClose( this.testSuitePath );
  this.provider.finit();
}

//

function pathFor( filePath )
{
  let path = this.provider.path;
  filePath =  path.join( this.testSuitePath, filePath );
  return path.normalize( filePath );
}

// --
// tests
// --

function readWriteCson( test )
{
  let self = this;
  let provider = self.provider;
  let path = provider.path;
  let testPath = self.pathFor( 'written/' + test.name );
  let testFilePath = path.join( testPath, 'config.cson' );

  /**/

  let src =
  {
    string: 'string',
    number: 1.123,
    bool: false,
    array: [ 1, '1', true ],
    regexp: /\.string$/,
    map: { a: 'string', b: 1, c: false },
  }

  let src2 = { a0 : { b0 : { c0 : { p : 1 }, c1 : 1 }, b1 : 1 }, a1 : 1 };

  /**/

  test.case = 'write and read cson file, using map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src, encoding : 'cson' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'cson' });
  test.identical( got, src );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`string: 'string'
number: 1.123
bool: false
array: [
  1
  '1'
  true
]
regexp: /\\.string$/
map:
  a: 'string'
  b: 1
  c: false
`
  test.identical( got,expected )

  /**/

  test.case = 'write and read cson file, using complex map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src2, encoding : 'cson' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'cson' });
  test.identical( got, src2 );
  var got = provider.fileRead({ filePath : testFilePath });
  console.log( got )
  var expected =
`a0:
  b0:
    c0: p: 1
    c1: 1
  b1: 1
a1: 1
`
  test.identical( got,expected )
}

//

function readWriteYaml( test )
{
  let self = this;
  let provider = self.provider;
  let path = provider.path;
  let testPath = self.pathFor( 'written/' + test.name );
  let testFilePath = path.join( testPath, 'config.yml' );

  /**/

  let src =
  {
    string: 'string',
    number: 1.123,
    bool: false,
    array: [ 1, '1', true ],
    regexp: /\.string$/,
    map: { a: 'string', b: 1, c: false },
  }

  let src2 = { a0 : { b0 : { c0 : { p : 1 }, c1 : 1 }, b1 : 1 }, a1 : 1 };

  /* */

  test.case = 'write and read yaml file, using map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src, encoding : 'yaml' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'yaml' });
  test.identical( got, src );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`string: string
number: 1.123
bool: false
array:
  - 1
  - '1'
  - true
regexp: !<tag:yaml.org,2002:js/regexp> /\\.string$/
map:
  a: string
  b: 1
  c: false
`
  test.identical( got,expected )

  /**/

  test.case = 'write and read yaml file, using complex map as data';
  provider.filesDelete( testPath );
  provider.fileWrite({ filePath : testFilePath, data : src2, encoding : 'yaml' });
  var got = provider.fileRead({ filePath : testFilePath, encoding : 'yaml' });
  test.identical( got, src2 );
  var got = provider.fileRead({ filePath : testFilePath });
  var expected =
`a0:
  b0:
    c0:
      p: 1
    c1: 1
  b1: 1
a1: 1
`
  test.identical( got,expected )

}

// --
// declare
// --

var Self =
{

  name : 'Tools/mid/files/EncodersExtended',
  silencing : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  context :
  {
    testSuitePath : null,
    pathFor : pathFor,
    provider : null,
  },

  tests :
  {
    readWriteCson,
    readWriteYaml
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );