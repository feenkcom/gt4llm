"
I am the markdown format of a Lepiter page: the page title and ids, and the page rendered as markdown by GtLLepiterContentExporter, as chats get pages. I am the smallest format and have no snippet ids: use me to read a page that will not be edited.
"
Class {
	#name : #GtLLepiterPageMarkdownContent,
	#superclass : #GtLLepiterPageContent,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLLepiterPageMarkdownContent class >> formatName [
	^ 'markdown'
]

{ #category : #accessing }
GtLLepiterPageMarkdownContent >> llmJsonObject [
	^ self pageAttributes
		at: 'markdown' put: self markdown;
		yourself
]

{ #category : #accessing }
GtLLepiterPageMarkdownContent >> markdown [
	"Return the page as markdown, as chats get pages. A snippet that cannot be exported is given as its text; line endings are line feeds"

	^ (GtLLepiterContentExporter new
		strictMode: false;
		page: page;
		export) withUnixLineEndings
]
