Class {
	#name : #GtLGrepMatchRange,
	#superclass : #Object,
	#instVars : [
		'startLine',
		'startColumn',
		'path',
		'matchString',
		'startIndex'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLGrepMatchRange >> endIndex [
	^ startIndex + matchString size
]

{ #category : #'as yet unclassified' }
GtLGrepMatchRange >> gtDisplayOn: stream [
	stream
		nextPutAll: self path;
		space;
		nextPutAll: self matchString storeString;
		space;
		nextPutAll: self startIndex asString
]

{ #category : #private }
GtLGrepMatchRange >> matchString [
	^ matchString
]

{ #category : #private }
GtLGrepMatchRange >> matchString: aString [ 
	matchString := aString
]

{ #category : #magritte }
GtLGrepMatchRange >> matchStringDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Match string';
		accessor: #matchString;
		beRequired
]

{ #category : #private }
GtLGrepMatchRange >> path [
	^ path
]

{ #category : #private }
GtLGrepMatchRange >> path: aString [ 
	path := aString
]

{ #category : #magritte }
GtLGrepMatchRange >> pathDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Path';
		accessor: #path;
		beRequired
]

{ #category : #accessing }
GtLGrepMatchRange >> startColumn [
	^ startColumn
]

{ #category : #accessing }
GtLGrepMatchRange >> startColumn: anInteger [
	startColumn := anInteger
]

{ #category : #magritte }
GtLGrepMatchRange >> startColumnDescription [
	<magritteDescription>

	^ MANumberDescription new
		label: 'Start column';
		accessor: #startColumn;
		beRequired
]

{ #category : #accessing }
GtLGrepMatchRange >> startIndex [
	^ startIndex
]

{ #category : #private }
GtLGrepMatchRange >> startIndex: aNumber [ 
	startIndex := aNumber
]

{ #category : #magritte }
GtLGrepMatchRange >> startIndexDescription [
	<magritteDescription>

	^ MANumberDescription new
		label: 'Start index';
		accessor: #startIndex;
		beRequired
]

{ #category : #accessing }
GtLGrepMatchRange >> startLine [
	^ startLine
]

{ #category : #accessing }
GtLGrepMatchRange >> startLine: anInteger [
	startLine := anInteger
]

{ #category : #magritte }
GtLGrepMatchRange >> startLineDescription [
	<magritteDescription>

	^ MANumberDescription new
		label: 'Start line';
		accessor: #startLine;
		beRequired
]
