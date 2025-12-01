Class {
	#name : #GtLOpenAIFineTuningEventsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFineTuningEventsGroup class >> itemClass [
	^ GtLOpenAIFineTuningEvent
]

{ #category : #accessing }
GtLOpenAIFineTuningEventsGroup >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self items ];
		column: 'Level' text: #level weight: 0.5;
		column: 'Message' text: #message weight: 2;
		column: 'Time' text: #createdAt weight: 0.5
]
