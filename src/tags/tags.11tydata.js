module.exports = {
  eleventyComputed: {
    title: data => `Posts in ${data.tag.name}`
  },
}
