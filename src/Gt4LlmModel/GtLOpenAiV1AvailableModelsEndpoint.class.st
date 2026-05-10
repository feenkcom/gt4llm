Class {
	#name : #GtLOpenAiV1AvailableModelsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLOpenAiV1AvailableModelsEndpoint >> path [

	^ '/api/v1/models'
]

{ #category : #'as yet unclassified' }
GtLOpenAiV1AvailableModelsEndpoint >> resultFrom: aResponse [
	| modelsArray |

	modelsArray := aResponse result at: 'models'.
	^ modelsArray groupedBy: 
		[ :modelDetails | modelDetails at: 'display_name' ].
]
