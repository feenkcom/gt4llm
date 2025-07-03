Class {
	#name : #GtBPEEncodingResult,
	#superclass : #Object,
	#instVars : [
		'input',
		'tokens',
		'stats',
		'merges',
		'output'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtBPEEncodingResult >> compressionRatio [
	self output size = 0 ifTrue: [ ^ self tokens size ].
	^ self tokens size / self output size
]

{ #category : #accessing }
GtBPEEncodingResult >> gtCompressionRatioFor: aView [
	<gtView>
	^ aView forward
		title: 'Compression ratio';
		priority: 5;
		object: [ self compressionRatio ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtBPEEncodingResult >> gtInputFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 2;
		text: [ self input ]
]

{ #category : #accessing }
GtBPEEncodingResult >> gtInputTokensFor: aView [
	<gtView>
	^ aView forward
		title: 'Input tokens';
		priority: 3;
		object: [ self tokens ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtBPEEncodingResult >> gtMergesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Merges';
		priority: 4;
		items: [ self merges associations ];
		column: 'Input pair' text: [ :aPair | ', ' join: aPair key ];
		column: 'Output token' text: #value
]

{ #category : #accessing }
GtBPEEncodingResult >> gtOutputFor: aView [
	<gtView>
	^ aView forward
		title: 'Output';
		priority: 1;
		object: [ self output ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtBPEEncodingResult >> input [
	^ input
]

{ #category : #accessing }
GtBPEEncodingResult >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtBPEEncodingResult >> merges [
	^ merges
]

{ #category : #accessing }
GtBPEEncodingResult >> merges: anObject [
	merges := anObject
]

{ #category : #accessing }
GtBPEEncodingResult >> output [
	^ output
]

{ #category : #accessing }
GtBPEEncodingResult >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtBPEEncodingResult >> stats [
	^ stats
]

{ #category : #accessing }
GtBPEEncodingResult >> stats: anObject [
	stats := anObject
]

{ #category : #accessing }
GtBPEEncodingResult >> tokens [
	^ tokens
]

{ #category : #accessing }
GtBPEEncodingResult >> tokens: anObject [
	tokens := anObject
]
