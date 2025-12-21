Class {
	#name : #GtLMarkdown,
	#superclass : #Object,
	#instVars : [
		'description'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLMarkdown >> description [
	^ description
]

{ #category : #accessing }
GtLMarkdown >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLMarkdown >> descriptionDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #description;
		  comment: '{
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
}';
		  beRequired
]

{ #category : #views }
GtLMarkdown >> gtMarkdownFor: aView [
	<gtView>
	description ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Markdown';
		priority: 1;
		styler: (GtLMessageStyler new);
		text: [ description ]
]
