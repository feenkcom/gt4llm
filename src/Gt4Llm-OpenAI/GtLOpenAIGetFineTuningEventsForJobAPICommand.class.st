Class {
	#name : #GtLOpenAIGetFineTuningEventsForJobAPICommand,
	#superclass : #GtLOpenAIGetFineTuningJobAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningEventsForJobAPICommand >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/events' withParams: {'limit' -> 1000}
]

{ #category : #accessing }
GtLOpenAIGetFineTuningEventsForJobAPICommand >> serializationClass [
	^ GtLOpenAIFineTuningEventsGroup
]
