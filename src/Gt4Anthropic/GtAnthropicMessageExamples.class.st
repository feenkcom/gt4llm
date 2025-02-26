Class {
	#name : #GtAnthropicMessageExamples,
	#superclass : #GtLlmThreadMessageExamples,
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> basicMessage [
	<gtExample>
	| aMessage |
	aMessage := GtAnthropicChatMessage new.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> basicToolMessage [
	<gtExample>
	| aMessage |
	aMessage := GtAnthropicToolMessage new.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> filledToolMessage [
	<gtExample>
	| aMessage |
	aMessage := self basicToolMessage id: UUID new; contentText: 'Tool output'.
	
	self assert: aMessage senderText equals: 'Tool'.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> greetingMessage [
	<gtExample>
	| aJson aMessage |
	aJson := self greetingMessageJson.
	aMessage := GtAnthropicChatMessage from: aJson.

	self assert: aMessage contentText equals: 'Hi! My name is Claude.'.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> greetingMessageJson [
	^ NeoJSONObject
		fromString: '{
  "content": [
    {
      "text": "Hi! My name is Claude.",
      "type": "text"
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJJKqJ2EF",
  "model": "claude-3-5-sonnet-20241022",
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 2095,
    "output_tokens": 503
  }
}'
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> messageWithToolUse [
	<gtExample>
	| aJson aMessage |
	aJson := self toolUseMessageJson.
	aMessage := GtAnthropicChatMessage from: aJson.

	self assert: aMessage contentText equals: 'I will look up the current weather.'.
	self assert: aMessage toolCalls size equals: 1.
	self assert: aMessage toolCalls first name equals: 'get_weather'.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicMessageExamples >> toolUseMessageJson [
	^ NeoJSONObject
		fromString: '{
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "I will look up the current weather."
    },
    {
      "type": "tool_use",
      "id": "toolu_01A09q90qw90lq917835lq9",
      "name": "get_weather",
      "input": {"location": "San Francisco, CA"}
    }
  ]
}'
]
