Class {
	#name : #GtLResponseMarkdownFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseMarkdownFormat >> asJsonSchemaDictionary [
	^ schema raw
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema details';
		priority: 5;
		object: [ schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Properties';
		priority: 10;
		object: [ schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #initialization }
GtLResponseMarkdownFormat >> initialize [
	super initialize.
	
	schema := NeoJSONSchema new
					json: (NeoJSONObject
							fromString: '{
	"description" : "This is a Markdown format with a few extensions.

Annotate Smalltalk classes using `{{gtClass:ClassName}}`, where `ClassName` is the name of the class to be referenced.

Annotate Smalltalk methods using `{{gtMethod:ClassName>>#methodName}}`, where `ClassName` is the name of the class and `methodName` is the name of the method.

Use blockquote for code.

Denote code snippet in Smalltalk with:
```smalltalk
Point x: 1 y: 10
```

Denote a Smalltalk method with:
```smalltalk-method
SomeClass>>someMethodWithArgument: val
	^ self + val
```

Denote the definition of a new Smalltalk class in the form of a script:
```smalltalk
Object subclass: #SomeClass
	instanceVariableNames: ''someSlotA someSlotB''
	classVariableNames: ''
	package: ''SomePackage''
```

Denote SmaCC grammar definitions as:
```smacc-grammar
%root FileNode;
<line>
	: [^\r\n]+
	;
<newLine>
	: \r | \n | \r\n
	;
File
	: Lines {{FileNode}}
	;
Lines
	: Line
	| Lines <newLine> Line
	;
Line
	: 
	| <line> ''line''
	;
```
",
	"type" : "string"
}')
]

{ #category : #printing }
GtLResponseMarkdownFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> propertyNames [
	^ #()
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> schema: aSchema [
	schema := aSchema
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> type [
	^ schema type
]
