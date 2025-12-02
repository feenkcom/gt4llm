Class {
	#name : #GtLOpenAIGetFineTuningCheckpointsForJobAPICommand,
	#superclass : #GtLOpenAIGetFineTuningJobAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningCheckpointsForJobAPICommand >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/checkpoints'
]

{ #category : #accessing }
GtLOpenAIGetFineTuningCheckpointsForJobAPICommand >> serializationClass [
	^ GtLOpenAIFineTuningCheckpointsGroup
]
