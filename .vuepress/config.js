module.exports = {
    port: 80,
    patterns: ['**/*.md', '!**/backup/*.md'],
    title: 'pandaria',
    description: '刚毅坚卓',
    dest: '.vuepress/public',
    theme: 'reco',
    themeConfig: {
        type: 'blog',
        author: 'bazoookia',
        nav: [
            { text: 'Home', link: '/', icon: 'reco-home' },
            { text: 'TimeLine', link: '/timeline/', icon: 'reco-date' }
        ],
        search: true,
        searchMaxSuggestions: 10,
        sidebar: 'auto',
        plugins: ['@vuepress/medium-zoom', 'flowchart']
    },
    markdown: {
        lineNumbers: true
    }
}
