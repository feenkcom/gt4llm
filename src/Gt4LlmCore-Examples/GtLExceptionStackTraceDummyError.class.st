"
I am an error whose signaler context is not a context, so that trimming my stack raises: GtLExceptionStackTraceExamples use me to reach the untrimmed fallback of GtLValueSerializer>>#stackTraceOf:.
"
Class {
	#name : #GtLExceptionStackTraceDummyError,
	#superclass : #Error,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #accessing }
GtLExceptionStackTraceDummyError >> signalerContext [
	"Not a context, so that trimming the stack raises"

	^ Object new
]
