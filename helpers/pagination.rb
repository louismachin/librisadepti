WORKS_PER_PAGE = 16

def get_page(works, page_no = 1)
    chunks = works.each_slice(WORKS_PER_PAGE).to_a
    page_count = chunks.size
    page_no = page_no.clamp(1, page_count)
    page = chunks[page_no - 1]
    return [page, page_count]
end