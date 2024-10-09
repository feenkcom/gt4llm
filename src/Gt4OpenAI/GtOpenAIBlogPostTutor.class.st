Class {
	#name : #GtOpenAIBlogPostTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> blogPostFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Blog post';
		priority: 1;
		format: 'text';
		example: '```
This node contains plain text for the blog post.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted, and code blocks may be used.

# Headings exist as well
```'
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> chatClass [
	^ GtOpenAIBlogpostAssistantChat
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> continueAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Continue the blog post';
		priority: 1;
		description: 'Continues writing the blog post.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Continue the blog post'.
							'Blog post'
								-> '# What exactly is Glamorous Toolkit v1.0?

Glamorous Toolkit (GT) is the Moldable Development Environment. Version 1.0 embodies more than 6 years of development and is the result of some 14 years of research. Our goal is to make systems explainable by means of custom tools created for each problem. Glamorous Toolkit makes this possible by making the creation of custom tools inexpensive and seamless.'}
							asDictionary;
					output: {'Action' -> 'Continue the blog post'.
							'Text' -> nil.
							'Blog post'
								-> '# What exactly is Glamorous Toolkit v1.0?

Glamorous Toolkit (GT) is the Moldable Development Environment. Version 1.0 embodies more than 6 years of development and is the result of some 14 years of research. Our goal is to make systems explainable by means of custom tools created for each problem. Glamorous Toolkit makes this possible by making the creation of custom tools inexpensive and seamless.

Glamorous Toolkit is primarily implemented in Pharo and offers a complete development experience for Pharo, too, but with a few twists. In this blog post, we will look at some of those twists that make Glamorous Toolkit a unique Development Environment.'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> formatName [
	^ 'writing blog post'
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> messageClass [
	^ GtOpenAIBlogPostAssistantThreadMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the blog post';
		priority: 1;
		description: 'Reviews and criticizes the current state of the blog post, including style, length, and grammar, like a regular polite yet firm reviewer would. If a rewrite is proposed, it will be proposed in the blog post, not just in the text.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Review the blog post'.
							'Blog post'
								-> '# What exactly is Glamorous Toolkit v1.0?

Glamorous Toolkit (GT) is the Moldable Devlopment Environment. Version 1.0 embodies more than 6 years of development and is the result of some 14 years of research. Our goal is to make systems explainable by means of custom tools created for each problem. Glamorous Toolkit makes this possible by making the creation of custom tools inexpensive and seamless.'}
							asDictionary;
					output: {'Action' -> 'Review the blog post'.
							'Text'
								-> 'This is a good start to a compelling blog post about Moldable Development! I took the liberty of fixing a typo (`development` was misspelled as `devlopment`.

You might want to continue by explaining what Glamorous Toolkit actually is, and then continue by diving deeper into any specifics you would like to highlight. I added a sentence you could continue with if desired. Have fun!'.
							'Blog post'
								-> '# What exactly is Glamorous Toolkit v1.0?

Glamorous Toolkit (GT) is the Moldable Development Environment. Version 1.0 embodies more than 6 years of development and is the result of some 14 years of research. Our goal is to make systems explainable by means of custom tools created for each problem. Glamorous Toolkit makes this possible by making the creation of custom tools inexpensive and seamless.

Glamorous Toolkit is primarily implemented in Pharo and offers a complete development experience for Pharo, too, but with a few twists. In this blog post, we will look at some of those twists that make Glamorous Toolkit a unique Development Environment.'}
							asDictionary}
]
