Class {
	#name : #GtLOllamaCreateModelCommand,
	#superclass : #GtLModelApiCommand,
	#category : #'Gt4Llm-Ollama-Commands'
}

{ #category : #'private - accessing' }
GtLOllamaCreateModelCommand >> newContext [

	^ GtLOllamaCreateModelContext new
]

{ #category : #'as yet unclassified' }
GtLOllamaCreateModelCommand >> perform [
	| requestResponse endpoint |

	endpoint := context endpoint.
	requestResponse := self client
		post: endpoint path
		withEntity: (endpoint entityFromContext: context).
	^ endpoint resultFrom: requestResponse context: context.
]
