"
Signals that session-file rollback failed. Retains both errors; the writer refuses further writes.
"
Class {
	#name : #GtLChatSessionWriterRecoveryError,
	#superclass : #Error,
	#instVars : [
		'writeError',
		'rollbackError'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #accessing }
GtLChatSessionWriterRecoveryError >> rollbackError [
	^ rollbackError
]

{ #category : #accessing }
GtLChatSessionWriterRecoveryError >> writeError [
	^ writeError
]

{ #category : #accessing }
GtLChatSessionWriterRecoveryError >> writeError: anError rollbackError: anotherError [
	writeError := anError.
	rollbackError := anotherError.
	self
		messageText: 'Session write failed (' , anError messageText , '); rollback failed ('
				, anotherError messageText
				, '). Writer disabled; repair the file before retrying with a new writer.'
]
