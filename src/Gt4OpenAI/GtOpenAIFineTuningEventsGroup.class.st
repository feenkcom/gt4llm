Class {
	#name : #GtOpenAIFineTuningEventsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFineTuningEventsGroup class >> itemClass [
	^ GtOpenAIFineTuningEvent
]

{ #category : #accessing }
GtOpenAIFineTuningEventsGroup >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self items ];
		column: 'Level' text: #level weight: 0.5;
		column: 'Message' text: #message weight: 2;
		column: 'Time' text: #createdAt weight: 0.5
]
