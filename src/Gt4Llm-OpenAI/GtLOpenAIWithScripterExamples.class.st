Class {
	#name : #GtLOpenAIWithScripterExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-OpenAI-Examples'
}

{ #category : #examples }
GtLOpenAIWithScripterExamples >> howAreYouCallExample_withStringSchema [
	<gtExample>
	| aChat aScripter |
	aChat := GtLChatOpenAILiveExamples new howAreYouCallExample_withStringSchema.
	aScripter := BlScripter new.
	aScripter element: aChat asElement.

	aScripter llmChat
		assertMessageElementExistsWithIndex: 2;
		play.
		
	aScripter assert
		onThisOrDeepChildElementId: #'chat--message-list';
		/ #scrollable;
		// (GtLMessageElementId indexed: 2);
		// #verticalScrollbar;
		/ #scrollbar;
		value: [ :anElement | anElement visibility ] equals: BlVisibility hidden;
		play.

	^ aScripter
]
