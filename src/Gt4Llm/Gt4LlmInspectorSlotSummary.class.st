Class {
	#name : #Gt4LlmInspectorSlotSummary,
	#superclass : #Object,
	#instVars : [
		'slot',
		'name',
		'slotValue'
	],
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> name [
	^ name
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> name: anObject [
	name := anObject
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> slot [
	^ slot
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> slot: anObject [
	slot := anObject
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> slotValue [
	^ slotValue
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> slotValue: anObject [
	slotValue := anObject
]

{ #category : #accessing }
Gt4LlmInspectorSlotSummary >> summaryString [
	^ self name, ': ', self slotValue asString
]
