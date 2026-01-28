Class {
	#name : #GtLFunctionToolWithProtocol,
	#superclass : #GtLFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLFunctionToolWithProtocol class >> leJsonV4Name [
	^ #gtLFunctionToolWithProtocol
]

{ #category : #'as yet unclassified' }
GtLFunctionToolWithProtocol >> block: aBlock [
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
GtLFunctionToolWithProtocol >> description [
	^ description, '

', self protocolDescription
]

{ #category : #'as yet unclassified' }
GtLFunctionToolWithProtocol >> protocolDescription [
	^ 'On success, an object of the form `{"type": "result", "value": "... result ... "}` will be returned. On error, an object of the form `{"type": "error", "error": "... error message ... "}` will be returned.'
]
