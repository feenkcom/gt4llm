Class {
	#name : #GtLlmInspectorSlotSummaryGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInspectorSlotSummaryGroup >> gtSlotsFor: aView [
	<gtView>
	^ aView columnedList title: 'Slots'; priority: 1; items: [self items]; column: 'Name' text: #name; column: 'Value' text: #slotValue
]
