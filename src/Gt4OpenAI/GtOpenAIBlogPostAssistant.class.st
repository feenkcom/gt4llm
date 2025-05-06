Class {
	#name : #GtOpenAIBlogPostAssistant,
	#superclass : #GtLlmAssistant,
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> createChatOn: aText [
	| chat |
	chat := self createChat.
	chat onInstance: (self valueHolderFor: aText).
	^ chat
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> defaultDescription [
	^ 'You are an assistant that is used to interactively work on blog posts. You trigger certain actions to generate a desired result.'
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> gtCorrectGrammar [
 	<gtLlmAssistantAction>
 	^ GtLlmAssistantAction new
	    name: 'Correct grammar';
	    priority: 10;
		description: 'Correct grammar. Place the result in the `Post` property.';
		examples: {GtLlmAssistantActionExample new
	input: { 'Action' -> 'Correct grammar'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. There are a number of recent article proposes mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs are generators of possibilities that should be evaluated against reality before being relied upon for decision making in a technical space.

That is why I favor (B) especially when combined with a moldable development environment. When we get the tools we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target LLMs.

Oh yes, I know, agents can add include feedback when generating solutions. But even then, there is no reason to not expose biases. In a technical space we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary;
	output: { 'Action' -> 'Correct grammar'. 'Text' -> nil. 'Post' -> 'There are at least two ways to use LLMs for supporting the understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. A number of recent articles propose mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs as generators of possibilities that should be evaluated against reality before being relied upon for decision-making in a technical space.

That is why I favor (B), especially when combined with a moldable development environment. When we get the tools, we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision-making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target for LLMs.

Oh yes, I know, agents can include feedback when generating solutions. But even then, there is no reason not to expose biases. In a technical space, we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary}
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> gtCreateTitle [
 	<gtLlmAssistantAction>
 	^ GtLlmAssistantAction new
	    name: 'Create title';
	    priority: 10;
		description: 'Create title. Put result in the `Text` property. Do not use quotes of any kind. Be crisp.';
		examples: {GtLlmAssistantActionExample new
	input: { 'Action' -> 'Create Title'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. There are a number of recent article proposes mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs are generators of possibilities that should be evaluated against reality before being relied upon for decision making in a technical space.

That is why I favor (B) especially when combined with a moldable development environment. When we get the tools we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target LLMs.

Oh yes, I know, agents can add include feedback when generating solutions. But even then, there is no reason to not expose biases. In a technical space we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary;
	output: { 'Action' -> 'Create Title'. 'Text' -> 'Leveraging LLMs for Informed Software Understanding'. 'Post' -> nil } asDictionary}
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> gtPostFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
	type: ((OrderedCollection new) add: 'string'; add: 'null'; yourself);
	format: 'Text';
	name: 'Post';
	priority: 10;
	example: ''
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> treatProvider: aProvider [
	super treatProvider: aProvider.

	aProvider
		assistantMessageClass: GtOpenAIBlogPostMessage;
		userMessageClass: GtOpenAIBlogPostMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistant >> valueHolderFor: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Post';
		content: anObject;
		serializer: #asString;
		updater: [ :aText :aString | 
			aText deleteAll
				appendString: aString;
				yourself ]
]
