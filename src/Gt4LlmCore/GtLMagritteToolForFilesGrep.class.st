Class {
	#name : #GtLMagritteToolForFilesGrep,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'resultLimit'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteToolForFilesGrep >> description [
	^ 'Greps for a query string in a file or directory. Arguments must provide a query string and a filePath.

Example JSON arguments:
{
  "query": "needle",
  "filePath": "/path/to/one.txt"
}

Example JSON response:
{
  "query": "needle",
  "files": [
    {
      "pathString": "/path/to/one.txt",
      "ranges": [
        {"startLine": 1, "startColumn": 0, "endLine": 1, "endColumn": 5}
      ]
    }
  ]
}'
]

{ #category : #accessing }
GtLMagritteToolForFilesGrep >> filePathDescription [
	<magritteDescription>

	^ MAToOneRelationDescription new
		accessor: #filePath;
		classes: {GtLFilePathReference};
		beRequired
]

{ #category : #initialization }
GtLMagritteToolForFilesGrep >> initialize [
	super initialize.
	resultLimit := 2000
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> limitedOutputLines: aString [
	| lines |
	lines := aString lines.
	lines size > self resultLimit
		ifTrue: [ ^ lines first: self resultLimit ].
	^ lines
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> matchRangesForQuery: aQuery inFileReference: aFileReference [
	| process lines |
	process := GtShellScriptProcess new
			script: (self scriptForQuery: aQuery filePath: aFileReference pathString).
	process start.
	self waitForProcess: process.
	process isSuccess not ifTrue: [ ^ {} ].
	lines := self limitedOutputLines: process output.
	^ self parseGrepOutputLines: lines
]

{ #category : #accessing }
GtLMagritteToolForFilesGrep >> name [
	^ 'grepFiles'
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> parseGrepOutputLines: lines [
	| ranges |
	ranges := OrderedCollection new.
	lines
		do: [ :line | 
			| parsed |
			parsed := self ripgrepLineParser parse: line.
			parsed isPetit2Failure ifTrue: [ ^ ranges ].
			ranges add: parsed ].
	^ ranges
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> privatePerformToolCall: aToolCall [
	| arguments query filePath files fileReference ranges |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
			at: 'query'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'query' ].
	filePath := arguments
			at: 'filePath'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'filePath' ].
	fileReference := filePath asFileReference.
	fileReference exists
		ifFalse: [ ^ GtLMissingDomainObject new objectName: filePath pathString asString ].
	ranges := self matchRangesForQuery: query inFileReference: fileReference.
	files := (ranges groupedBy: [ :r | r path ]) associations
			collect: [ :assoc | 
				GtLGrepFilePathReference new
					pathString: assoc key;
					ranges: assoc value ].
	^ GtLGrepFilesMatches new
		query: query;
		files: files
]

{ #category : #magritte }
GtLMagritteToolForFilesGrep >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForFilesGrep >> resultLimit [
	^ resultLimit ifNil: [ 1000 ]
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> ripgrepLineParser [
	| path number message |
	path := ($: asPParser negate) plus flatten.
	number := #digit asPParser plus flatten ==> [ :s | s asNumber ].
	message := #any asPParser star flatten.
	^ ((path , $: asPParser , number , $: asPParser , number , $: asPParser ,number , $: asPParser , message)
		==> [ :nodes | 
		GtLGrepMatchRange new
						path: nodes first;
						startLine: nodes third;
						startColumn: nodes fifth;
						startIndex: nodes seventh;
						matchString: nodes ninth ])
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> scriptForQuery: aQuery filePath: aPathString [
	^ 'rg --no-heading --with-filename --byte-offset -o -n --column -- ' , aQuery storeString , ' ' , aPathString storeString
]

{ #category : #private }
GtLMagritteToolForFilesGrep >> waitForProcess: aProcess [
	| deadline |
	deadline := Time millisecondClockValue + 60000.
	[ aProcess isSuccess or: [ aProcess isFailure or: [ Time millisecondClockValue > deadline ] ] ] whileFalse: [
		50 milliSeconds wait ].
	^ aProcess didRun
]
