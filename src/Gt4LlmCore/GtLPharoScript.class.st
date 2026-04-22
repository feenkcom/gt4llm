Class {
	#name : #GtLPharoScript,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLPharoScript class >> content: aString [
	^ self new content: aString
]

{ #category : #accessing }
GtLPharoScript >> asJsonDictionary [
	^ {'content' -> self content} asDictionary
]

{ #category : #accessing }
GtLPharoScript >> content [
	^ content
]

{ #category : #accessing }
GtLPharoScript >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtLPharoScript >> contentDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #content;
		  comment: 'This is a Pharo script. It must contain correct Pharo code that can be executed, including appropriate temporary variable declarations.';
		  beRequired
]

{ #category : #'as yet unclassified' }
GtLPharoScript >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream nextPutAll: content ]
]

{ #category : #views }
GtLPharoScript >> gtScriptFor: aView [
	<gtView>
	<gtLlmView>
	content ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Script';
		priority: 1;
		stencil: [ (GtPharoSnippetCoder new
				forSource: content;
				subscribeToSystem;
				asExpandedOnlyElement) vFitContentLimited ]
]
