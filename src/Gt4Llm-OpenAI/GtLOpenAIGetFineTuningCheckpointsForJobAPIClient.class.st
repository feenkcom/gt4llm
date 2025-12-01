Class {
	#name : #GtLOpenAIGetFineTuningCheckpointsForJobAPIClient,
	#superclass : #GtLOpenAIGetFineTuningJobAPIClient,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningCheckpointsForJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/checkpoints'
]

{ #category : #accessing }
GtLOpenAIGetFineTuningCheckpointsForJobAPIClient >> serializationClass [
	^ GtLOpenAIFineTuningCheckpointsGroup
]
