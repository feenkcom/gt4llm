Class {
	#name : #GtLOpenAIFineTuningCheckpointsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFineTuningCheckpointsGroup class >> itemClass [
	^ GtLOpenAIFineTuningCheckpoint
]

{ #category : #accessing }
GtLOpenAIFineTuningCheckpointsGroup >> gtCheckpointsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Checkpoints';
		priority: 1;
		items: [ self items ];
		column: 'Step number'
			text: #stepNumber
			weight: 0.5;
		column: 'Metrics'
			text: [ :aCheckpoint | 
				', '
					join: (aCheckpoint metrics associations
							collect: [ :aPair | aPair key , ': ' , aPair value asString ]) ]
			weight: 2;
		column: 'Time'
			text: #createdAt
			weight: 0.5
]
