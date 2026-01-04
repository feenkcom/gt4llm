Class {
	#name : #GtLMarkdown,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLMarkdown class >> content: aString [
	^ self new content: aString
]

{ #category : #accessing }
GtLMarkdown >> asJsonDictionary [
	^ {'content' -> self content} asDictionary
]

{ #category : #accessing }
GtLMarkdown >> content [
	^ content
]

{ #category : #accessing }
GtLMarkdown >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtLMarkdown >> contentDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #content;
		  comment: '{
	"description" : "This is a Markdown format with a few extensions.

Annotate Smalltalk classes using `{{gtClass:ClassName}}`, where `ClassName` is the name of the class to be referenced.

Annotate Smalltalk methods using `{{gtMethod:ClassName>>#methodName}}`, where `ClassName` is the name of the class and `methodName` is the name of the method.

For code use three backticks sections.

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
}';
		  beRequired
]

{ #category : #'as yet unclassified' }
GtLMarkdown >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream nextPutAll: content ]
]

{ #category : #views }
GtLMarkdown >> gtMarkdownFor: aView [
	<gtView>
	<gtLlmView>
	content ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Markdown';
		priority: 1;
		styler: (GtLMessageStyler new);
		text: [ content ]
]
