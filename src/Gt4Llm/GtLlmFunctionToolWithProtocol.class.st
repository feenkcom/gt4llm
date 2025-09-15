Class {
	#name : #GtLlmFunctionToolWithProtocol,
	#superclass : #GtLlmFunctionTool,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmFunctionToolWithProtocol class >> leJsonV4Name [

	^ #gtLlmFunctionToolWithProtocol
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolWithProtocol >> block: aBlock [
	block := [ :aFunctionCall | 
		STONJSON
			toString: ([ {'type' -> 'result'.
					'value' -> (aBlock cull: aFunctionCall) asString} asDictionary ]
					on: Error
					do: [ :e | 
						{'type' -> 'error'.
							'error' -> e asString} asDictionary ]) ]
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolWithProtocol >> description [
	^ description, '

', self protocolDescription
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolWithProtocol >> protocolDescription [
	^ 'On success, an object of the form `{"type": "result", "value": "... result ... "}` will be returned. On error, an object of the form `{"type": "error", "error": "... error message ... "}` will be returned.'
]
