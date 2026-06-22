Class {
	#name : #GtLDataSourceOpenAiCompletionsRequestParser,
	#superclass : #GtLDataSourceRequestParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #api }
GtLDataSourceOpenAiCompletionsRequestParser >> parseRequest: requestResponse at: index for: aMessageConstructor [

	| jsonRequest request messagesEntity role message chat |

	chat := aMessageConstructor chat.
	jsonRequest := requestResponse request asGtJson jsonObject.
	request := GtLOpenAiCompletionsRequestEntity rawData: jsonRequest.
	chat provider model ifNil:
		[ chat provider modelName: request model ].
	messagesEntity := request messages at: index.
	role := messagesEntity role.
	role = 'user' ifTrue:
		[ message := self parseUserRequest: requestResponse at: index messagesEntity: messagesEntity for: aMessageConstructor ].
	role = 'tool' ifTrue: [ ^ nil ].
	message ifNil:
		[ self error: 'Unknown role: ', role asString ].
	request tools ifNotNil: [ :toolsEntity |
		aMessageConstructor addToolsFrom: toolsEntity to: message ].
]

{ #category : #private }
GtLDataSourceOpenAiCompletionsRequestParser >> parseUserRequest: requestResponse at: index messagesEntity: messagesEntity for: aMessageConstructor [
	| contentEntity type message chat |
	
	chat := aMessageConstructor chat.
	contentEntity := messagesEntity content first.
	type := contentEntity type.
	type = 'text' ifFalse: [ self error: 'Unknown type: ', type asString ].
	message := GtLModelUserMessage new 
			string: contentEntity text;
			requestResponse: requestResponse.
	chat addUserMessage: message.
	^ message
]
