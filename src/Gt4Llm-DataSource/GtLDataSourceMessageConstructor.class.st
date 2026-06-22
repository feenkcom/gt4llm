"
Reconstruct chat messages from the supplied {{gtClass:GtLRequestHistory}}. 
"
Class {
	#name : #GtLDataSourceMessageConstructor,
	#superclass : #Object,
	#instVars : [
		'requestHistory',
		'messages',
		'chat'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> addToolsFrom: toolEntities to: message [
	| tools |

	tools := GtLTools new items: (toolEntities collect:
		[ :toolEntity | | name |
			name := toolEntity function at: 'name'.
			(GtLAbstractFunctionTool allSubclasses detect: [ :toolClass |
				toolClass new name = name ]) new ]).
	message tools: tools.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat [
	^ chat
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat: anObject [
	chat := anObject
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

	requestHistory doWithIndex: [ :requestResponse :index |
		self parseRequestResponse: requestResponse at: index ].
	^ chat
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseRequestResponse: requestResponse at: index [
	| requestParser responseParser |

	requestParser := self model optionAt: 'dataSourceRequestParser'.
	responseParser := self model optionAt: 'dataSourceResponseParser'.
	requestParser parseRequest: requestResponse at: index for: self.
	responseParser parseResponse: requestResponse at: index for: self.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory [
	^ requestHistory
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory: aGtLRequestHistory [

	requestHistory := aGtLRequestHistory
]
