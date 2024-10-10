Class {
	#name : #GtDPostTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
GtDPostTutor >> forObject: anObject [
	^ self valuePipelineFor: anObject withName: 'Post'
]

{ #category : #'as yet unclassified' }
GtDPostTutor >> formatName [
	^ 'post editor'
]

{ #category : #'as yet unclassified' }
GtDPostTutor >> gtCorrectGrammar [
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
	    name: 'Correct grammar';
	    priority: 10;
		description: 'Correct grammar. Place the result in the `Post` property.';
		examples: {GtLlmTutorActionExample new
	input: { 'Action' -> 'Correct grammar'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. There are a number of recent article proposes mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs are generators of possibilities that should be evaluated against reality before being relied upon for decision making in a technical space.

That is why I favor (B) especially when combined with a moldable development environment. When we get the tools we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). #MoldableDevelopment splits technical decision making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target LLMs.

Oh yes, I know, agents can add include feedback when generating solutions. But even then, there is no reason to not expose biases. In a technical space we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary;
	output: { 'Action' -> 'Correct grammar'. 'Text' -> 'Corrected grammar and text formatted.'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. A number of recent articles propose mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what trade-offs they contain. The alternative is to regard current LLMs as generators of possibilities that should be evaluated against reality before being relied upon for decision-making in a technical space.

That is why I favor (B), especially when combined with a moldable development environment. When we get the tools, we have a chance to review the bias and apply other forms of checks too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call "shallow" the questions whose answers can be evaluated against reality quickly). #MoldableDevelopment splits technical decision-making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target for LLMs.

Oh yes, I know agents can add and include feedback when generating solutions. But even then, there is no reason not to expose biases. In a technical space, we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary}
]

{ #category : #'as yet unclassified' }
GtDPostTutor >> gtCreateTitle [
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
	    name: 'Create title';
	    priority: 10;
		description: 'Create title. Put result in the `Text` property. Do not use quotes of any kind. Be crisp.';
		examples: {GtLlmTutorActionExample new
	input: { 'Action' -> 'Create title'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. A number of recent articles propose mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what trade-offs they contain. The alternative is to regard current LLMs as generators of possibilities that should be evaluated against reality before being relied upon for decision-making in a technical space.

That is why I favor (B), especially when combined with a moldable development environment. When we get the tools, we have a chance to review the bias and apply other forms of checks too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call "shallow" the questions whose answers can be evaluated against reality quickly). #MoldableDevelopment splits technical decision-making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target for LLMs.

Oh yes, I know agents can add and include feedback when generating solutions. But even then, there is no reason not to expose biases. In a technical space, we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary;
	output: { 'Action' -> 'Create title'. 'Text' -> 'Leveraging LLMs for Software System Understanding and Bias Management'. 'Post' -> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. A number of recent articles propose mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what trade-offs they contain. The alternative is to regard current LLMs as generators of possibilities that should be evaluated against reality before being relied upon for decision-making in a technical space.

That is why I favor (B), especially when combined with a moldable development environment. When we get the tools, we have a chance to review the bias and apply other forms of checks too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call "shallow" the questions whose answers can be evaluated against reality quickly). #MoldableDevelopment splits technical decision-making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target for LLMs.

Oh yes, I know agents can add and include feedback when generating solutions. But even then, there is no reason not to expose biases. In a technical space, we can nicely produce the tools we can use without intermediaries against the system.' } asDictionary}
]

{ #category : #'as yet unclassified' }
GtDPostTutor >> gtPostFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
	type: ((OrderedCollection new) add: 'string'; add: 'null'; yourself);
	format: 'Text';
	name: 'Post';
	priority: 10;
	example: ''
]

{ #category : #'as yet unclassified' }
GtDPostTutor >> messageClass [
	^ GtDPostMessage
]
