"
Reconstruct chat messages from the supplied {{gtClass:GtLRequestHistory}}. 
"
Class {
	#name : #GtLDataSourceMessageConstructor,
	#superclass : #Object,
	#instVars : [
		'requestHistory',
		'messages',
		'chat',
		'requestParser',
		'responseParser'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> addToolsFrom: toolEntities to: message [
	"Tools may require state that is not present in the datasource, so are replaced with a GtLJsonPlaceholderTool."
	| tools |

	tools := GtLTools new items: (toolEntities collect:
		[ :toolEntity |
			GtLJsonPlaceholderTool new
				entity: toolEntity ]).
	message tools: tools.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat [
	^ chat
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat: aGtLChat [

	chat := aGtLChat.
	requestParser := self model optionAt: 'dataSourceRequestParser'.
	responseParser := self model optionAt: 'dataSourceResponseParser'.
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> messages [

]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> model [

	^ chat provider model
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parse [
	"Parse the supplied requestHistory in to the supplied chat.
	The chat must be configured with a provider and model that matches the requestHistory (user responsibility at the moment)."

	requestHistory do: [ :requestResponse |
		self setChatFormatDescriptionsFrom: requestResponse.
		self parseRequestResponse: requestResponse ].
	chat tools: chat messages last tools.
	^ chat
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseRequestResponse: requestResponse [
	| message |
	
	message := requestParser parseRequest: requestResponse for: self.
	responseParser parseResponse: requestResponse message: message for: self.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory [
	^ requestHistory
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory: aGtLRequestHistory [

	requestHistory := aGtLRequestHistory
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> setChatFormatDescriptionsFrom: requestResponse [
	| content jsonResponse responseEntity |

	jsonResponse := requestResponse response asGtJson jsonObject.
	responseEntity := GtLOpenAiResponsesResponseEntity rawData: jsonResponse.
	content := responseEntity content.
	content isDictionary ifTrue:
		[ content at: 'Markdown'
			ifPresent: [ chat markdownResponse ] ].
]
