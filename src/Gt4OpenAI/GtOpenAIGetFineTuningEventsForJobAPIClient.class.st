Class {
	#name : #GtOpenAIGetFineTuningEventsForJobAPIClient,
	#superclass : #GtOpenAIGetFineTuningJobAPIClient,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGetFineTuningEventsForJobAPIClient >> request [
	^ self client get: '/fine_tuning/jobs/' , self job , '/events' withParams: {'limit' -> 1000}
]

{ #category : #accessing }
GtOpenAIGetFineTuningEventsForJobAPIClient >> serializationClass [
	^ GtOpenAIFineTuningEventsGroup
]
