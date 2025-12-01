Class {
	#name : #GtLOpenAIGetFineTuningEventsForJobAPIClient,
	#superclass : #GtLOpenAIGetFineTuningJobAPIClient,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFineTuningEventsForJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/events' withParams: {'limit' -> 1000}
]

{ #category : #accessing }
GtLOpenAIGetFineTuningEventsForJobAPIClient >> serializationClass [
	^ GtLOpenAIFineTuningEventsGroup
]
