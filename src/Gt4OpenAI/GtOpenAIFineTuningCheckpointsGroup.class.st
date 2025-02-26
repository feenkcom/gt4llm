Class {
	#name : #GtOpenAIFineTuningCheckpointsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFineTuningCheckpointsGroup class >> itemClass [
	^ GtOpenAIFineTuningCheckpoint
]

{ #category : #accessing }
GtOpenAIFineTuningCheckpointsGroup >> gtCheckpointsFor: aView [
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
