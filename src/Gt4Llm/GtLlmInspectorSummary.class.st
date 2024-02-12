Class {
	#name : #GtLlmInspectorSummary,
	#superclass : #Object,
	#instVars : [
		'objectClass',
		'slots',
		'views'
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
	^ 'A ' , self objectClass asString , ' (' , self object asString
		, ') with: 
'
		, ('
' join: (self slots collect: [ :aSlot | '- ' , aSlot summaryString ]))
		, '

Available views:
'
		, ('
' join: (self views collect: [ :aView | '- ' , aView summaryString ]))
]

{ #category : #accessing }
GtLlmInspectorSummary >> views [
	^ views
]

{ #category : #accessing }
GtLlmInspectorSummary >> views: anObject [
	views := anObject
]
