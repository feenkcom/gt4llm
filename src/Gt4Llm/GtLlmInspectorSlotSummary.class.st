Class {
	#name : #GtLlmInspectorSlotSummary,
	#superclass : #Object,
	#instVars : [
		'slot',
		'name',
		'slotValue'
	],
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmInspectorSlotSummary >> name [
	^ name
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> slot [
	^ slot
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> slot: anObject [
	slot := anObject
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> slotValue [
	^ slotValue
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> slotValue: anObject [
	slotValue := anObject
]

{ #category : #accessing }
GtLlmInspectorSlotSummary >> summaryString [
	^ self name, ': ', self slotValue asString
]
