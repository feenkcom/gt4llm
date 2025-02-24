Class {
	#name : #GtLlmInspectorSummary,
	#superclass : #Object,
	#instVars : [
		'objectClass',
		'slots',
		'views',
		'methods',
		'object'
	],
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmInspectorSummary >> gtPhlowViewsFor: aView [
	<gtView>
	^ aView forward
		title: 'Views';
		priority: 3;
		object: [ self views ];
		view: #gtPhlowViewsFor:
]

{ #category : #accessing }
GtLlmInspectorSummary >> gtSlotsFor: aView [
	<gtView>
	^ aView forward
		title: 'Slots';
		priority: 2;
		object: [ self slots ];
		view: #gtSlotsFor:
]

{ #category : #accessing }
GtLlmInspectorSummary >> gtSummaryFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Summary';
		priority: 1;
		text: [ self summaryString ]
]

{ #category : #accessing }
GtLlmInspectorSummary >> methods [
	^ methods
]

{ #category : #accessing }
GtLlmInspectorSummary >> methods: anObject [
	methods := anObject
]

{ #category : #accessing }
GtLlmInspectorSummary >> object [
	^ object
]

{ #category : #accessing }
GtLlmInspectorSummary >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLlmInspectorSummary >> objectClass [
	^ objectClass
]

{ #category : #accessing }
GtLlmInspectorSummary >> objectClass: anObject [
	objectClass := anObject
]

{ #category : #accessing }
GtLlmInspectorSummary >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: objectClass asString;
		nextPut: $)
]

{ #category : #accessing }
GtLlmInspectorSummary >> slots [
	^ slots
]

{ #category : #accessing }
GtLlmInspectorSummary >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
GtLlmInspectorSummary >> summaryString [
	| className article slotSummary viewSummary methodSummary |
	className := self objectClass asString.
	article := className first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ].

	slotSummary := self slots
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With slots:' , String cr , String cr
					, (String cr join: (self slots collect: [ :aSlot | aSlot summaryString ])) ].
	methodSummary := self methods
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With methods:' , String cr , String cr
					, (String cr join: (self methods collect: [ :aSlot | aSlot summaryString ])) ].
	viewSummary := self views
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With defined views:' , String cr
					, (String cr
							join: (self views collect: [ :aView | String cr , aView summaryString ])) ].

	^ 'an instance of ' , className , String cr , String cr , 'With print string: '
		, self object printString , String cr , String cr , slotSummary , String cr
		, String cr , methodSummary , String cr , String cr , viewSummary
]

{ #category : #accessing }
GtLlmInspectorSummary >> views [
	^ views
]

{ #category : #accessing }
GtLlmInspectorSummary >> views: anObject [
	views := anObject
]
