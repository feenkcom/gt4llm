Class {
	#name : #GtLChatCompactedSummary,
	#superclass : #GtLMarkdown,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLChatCompactedSummary class >> fromOpenAICompactionMessage: aMessage [
	^(aMessage formatDescriptions readDomainObjectsFrom: aMessage contentText) at: 'Compaction'
]

{ #category : #descriptions }
GtLChatCompactedSummary >> contentDescription [
	<magritteDescription>
	
	^ super contentDescription
		comment: 'The Chat Compaction Summary in the form of a Markdown format with a few extensions.' , 
		String cr, self commentForSmalltalk,
		String cr, self commentForSmaCC
]

{ #category : #'gt - extensions' }
GtLChatCompactedSummary >> gtMarkdownFor: aView [
	^ (super gtMarkdownFor: aView)
		title: 'Compaction Summary'
]
