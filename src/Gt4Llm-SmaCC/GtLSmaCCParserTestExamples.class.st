"
Examples validating the concise display of parser test requests, including incomplete requests.
"
Class {
	#name : #GtLSmaCCParserTestExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCParserTestExamples >> defaultStartingState [
	<gtExample>
	| aTest |
	aTest := GtLSmaCCParserTest new parserClass: 'LeParser'; yourself.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: LeParser (default)'.
	aTest startingState: ''.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: LeParser (default)'.
	^ aTest
]

{ #category : #examples }
GtLSmaCCParserTestExamples >> emptyExample [
	<gtExample>
	| aTest |
	aTest := GtLSmaCCParserTest new
		parserClass: 'LeParser';
		example: '';
		yourself.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: LeParser (default) with: ', '' printString.
	^ aTest
]

{ #category : #examples }
GtLSmaCCParserTestExamples >> namedStartingState [
	<gtExample>
	| aTest |
	aTest := GtLSmaCCParserTest new
		parserClass: 'LeParser';
		startingState: 'Table';
		example: '| a | b |', String lf, '|---|---|', String lf, '| c | **d** |';
		yourself.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: LeParser (Table) with: ', aTest example printString.
	^ aTest
]

{ #category : #examples }
GtLSmaCCParserTestExamples >> unspecifiedParser [
	<gtExample>
	| aTest |
	aTest := GtLSmaCCParserTest new.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: <unspecified parser> (default)'.
	aTest parserClass: ''.
	self assert: (String streamContents: [ :stream | aTest gtDisplayOn: stream ])
		equals: 'Test: <unspecified parser> (default)'.
	^ aTest
]
